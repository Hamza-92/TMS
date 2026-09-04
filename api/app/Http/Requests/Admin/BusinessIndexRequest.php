<?php

namespace App\Http\Requests\Admin;

use App\Enums\BusinessStatus;
use App\Enums\SubscriptionStatus;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class BusinessIndexRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, array<int, mixed>> */
    public function rules(): array
    {
        return [
            'q' => ['nullable', 'string', 'max:100'],
            'status' => ['nullable', Rule::enum(BusinessStatus::class)],
            'subscription' => [
                'nullable',
                Rule::in([
                    'none',
                    SubscriptionStatus::Trialing->value,
                    SubscriptionStatus::Active->value,
                    SubscriptionStatus::Grace->value,
                    SubscriptionStatus::Suspended->value,
                    SubscriptionStatus::Cancelled->value,
                    SubscriptionStatus::Expired->value,
                ]),
            ],
        ];
    }
}
