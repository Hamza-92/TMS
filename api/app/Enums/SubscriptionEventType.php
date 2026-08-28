<?php

namespace App\Enums;

enum SubscriptionEventType: string
{
    case Created = 'created';
    case Activated = 'activated';
    case Extended = 'extended';
    case Suspended = 'suspended';
    case Expired = 'expired';
    case Cancelled = 'cancelled';
}
