<?php

namespace App\Enums;

enum PaymentMethod: string
{
    case BankTransfer = 'bank_transfer';
    case GooglePlay = 'google_play';
    case Cash = 'cash';
    case Other = 'other';
}
