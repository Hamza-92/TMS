<?php

namespace App\Enums;

enum SubscriptionSource: string
{
    case Trial = 'trial';
    case GooglePlay = 'google_play';
    case BankTransfer = 'bank_transfer';
    case Cash = 'cash';
    case Complimentary = 'complimentary';
}
