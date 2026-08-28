<?php

namespace App\Enums;

enum DeletionRequestStatus: string
{
    case Requested = 'requested';
    case Approved = 'approved';
    case Processing = 'processing';
    case Completed = 'completed';
    case Cancelled = 'cancelled';
}
