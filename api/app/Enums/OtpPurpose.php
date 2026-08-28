<?php

namespace App\Enums;

enum OtpPurpose: string
{
    case Registration = 'registration';
    case ForgotPassword = 'forgot_password';
    case ChangePhone = 'change_phone';
    case NewDevice = 'new_device';
    case SensitiveAction = 'sensitive_action';
}
