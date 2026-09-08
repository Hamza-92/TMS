<?php

namespace App\Enums;

enum MeasurementStatus: string
{
    case Active = 'active';
    case Archived = 'archived';
    case Deleted = 'deleted';
}
