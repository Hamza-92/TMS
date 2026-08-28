<?php

namespace App\Enums;

enum AdminRole: string
{
    case Superadmin = 'superadmin';
    case Support = 'support';
    case Finance = 'finance';
}
