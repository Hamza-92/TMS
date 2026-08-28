<?php

namespace App\Enums;

enum SubscriptionActorType: string
{
    case System = 'system';
    case Admin = 'admin';
    case GooglePlay = 'google_play';
}
