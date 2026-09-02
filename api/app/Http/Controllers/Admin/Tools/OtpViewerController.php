<?php

namespace App\Http\Controllers\Admin\Tools;

use App\Http\Controllers\Controller;
use App\Models\OtpChallenge;
use App\Services\Otp\StagingOtpVault;
use Illuminate\Http\Request;
use Illuminate\View\View;

class OtpViewerController extends Controller
{
    public function __invoke(Request $request, StagingOtpVault $stagingOtpVault): View
    {
        $phone = $request->string('phone')->trim()->substr(0, 20)->value();

        $challenges = OtpChallenge::query()
            ->with('user:id,name')
            ->when($phone !== '', fn ($query) => $query->where('phone_e164', 'like', "%{$phone}%"))
            ->where('created_at', '>=', now()->subDay())
            ->latest()
            ->limit(50)
            ->get()
            ->map(fn (OtpChallenge $challenge): array => [
                'challenge' => $challenge,
                'code' => $stagingOtpVault->reveal($challenge),
            ]);

        return view('admin.tools.otps', [
            'challenges' => $challenges,
            'phone' => $phone,
        ]);
    }
}
