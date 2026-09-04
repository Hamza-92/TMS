<?php

namespace App\Services\Admin;

use App\Enums\BusinessStatus;
use App\Models\AdminAuditLog;
use App\Models\AdminUser;
use App\Models\Business;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class BusinessStatusService
{
    /** @throws ValidationException */
    public function suspend(
        Business $business,
        AdminUser $admin,
        string $reason,
        ?string $ipAddress,
        ?string $userAgent,
    ): Business {
        return DB::transaction(function () use ($business, $admin, $reason, $ipAddress, $userAgent): Business {
            $lockedBusiness = Business::query()->lockForUpdate()->findOrFail($business->id);

            if ($lockedBusiness->status !== BusinessStatus::Active) {
                throw ValidationException::withMessages([
                    'business' => 'Only an active business can be suspended.',
                ]);
            }

            $previousValues = $this->statusValues($lockedBusiness);

            $lockedBusiness->update([
                'status' => BusinessStatus::Suspended,
                'suspended_at' => now(),
                'suspension_reason' => trim($reason),
            ]);

            $this->audit(
                business: $lockedBusiness,
                admin: $admin,
                action: 'business.suspended',
                previousValues: $previousValues,
                newValues: $this->statusValues($lockedBusiness->refresh()),
                ipAddress: $ipAddress,
                userAgent: $userAgent,
            );

            return $lockedBusiness;
        });
    }

    /** @throws ValidationException */
    public function reactivate(
        Business $business,
        AdminUser $admin,
        ?string $ipAddress,
        ?string $userAgent,
    ): Business {
        return DB::transaction(function () use ($business, $admin, $ipAddress, $userAgent): Business {
            $lockedBusiness = Business::query()->lockForUpdate()->findOrFail($business->id);

            if ($lockedBusiness->status !== BusinessStatus::Suspended) {
                throw ValidationException::withMessages([
                    'business' => 'Only a suspended business can be reactivated.',
                ]);
            }

            $previousValues = $this->statusValues($lockedBusiness);

            $lockedBusiness->update([
                'status' => BusinessStatus::Active,
                'suspended_at' => null,
                'suspension_reason' => null,
            ]);

            $this->audit(
                business: $lockedBusiness,
                admin: $admin,
                action: 'business.reactivated',
                previousValues: $previousValues,
                newValues: $this->statusValues($lockedBusiness->refresh()),
                ipAddress: $ipAddress,
                userAgent: $userAgent,
            );

            return $lockedBusiness;
        });
    }

    /** @return array{status: string, suspended_at: ?string, suspension_reason: ?string} */
    private function statusValues(Business $business): array
    {
        return [
            'status' => $business->status->value,
            'suspended_at' => $business->suspended_at?->toIso8601String(),
            'suspension_reason' => $business->suspension_reason,
        ];
    }

    /**
     * @param  array<string, mixed>  $previousValues
     * @param  array<string, mixed>  $newValues
     */
    private function audit(
        Business $business,
        AdminUser $admin,
        string $action,
        array $previousValues,
        array $newValues,
        ?string $ipAddress,
        ?string $userAgent,
    ): void {
        AdminAuditLog::query()->create([
            'admin_user_id' => $admin->id,
            'business_id' => $business->id,
            'action' => $action,
            'subject_type' => Business::class,
            'subject_id' => $business->id,
            'previous_values' => $previousValues,
            'new_values' => $newValues,
            'ip_address' => $ipAddress,
            'user_agent' => $userAgent,
        ]);
    }
}
