<?php

namespace App\Enums;

enum BusinessRole: string
{
    case Owner = 'owner';
    case Manager = 'manager';
    case Staff = 'staff';
}
