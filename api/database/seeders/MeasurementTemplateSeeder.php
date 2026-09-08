<?php

namespace Database\Seeders;

use App\Enums\MeasurementStatus;
use App\Enums\MeasurementTemplateSource;
use App\Enums\MeasurementUnit;
use App\Models\MeasurementTemplate;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Ramsey\Uuid\Uuid;

class MeasurementTemplateSeeder extends Seeder
{
    public function run(): void
    {
        DB::transaction(function (): void {
            foreach ($this->templates() as $definition) {
                $template = MeasurementTemplate::query()->firstOrCreate(
                    ['system_code' => $definition['code']],
                    [
                        'business_id' => null,
                        'client_uuid' => $this->uuid("template:{$definition['code']}"),
                        'source' => MeasurementTemplateSource::System,
                        'name' => $definition['name'],
                        'name_ur' => $definition['name_ur'],
                        'name_roman_ur' => $definition['name_roman_ur'],
                        'category' => $definition['category'],
                        'default_unit' => MeasurementUnit::Inch,
                        'description' => $definition['description'],
                        'status' => MeasurementStatus::Active,
                        'version' => 1,
                        'current_definition_version' => 1,
                    ],
                );

                $version = $template->versions()->firstOrCreate(
                    ['version_number' => 1],
                    [
                        'name' => $definition['name'],
                        'name_ur' => $definition['name_ur'],
                        'name_roman_ur' => $definition['name_roman_ur'],
                        'category' => $definition['category'],
                        'default_unit' => MeasurementUnit::Inch,
                        'description' => $definition['description'],
                    ],
                );

                foreach ($definition['fields'] as $sortOrder => $field) {
                    $version->fields()->firstOrCreate(
                        ['field_key' => $field[0]],
                        [
                            'client_uuid' => $this->uuid("field:{$definition['code']}:{$field[0]}"),
                            'label' => $field[1],
                            'label_ur' => $field[2],
                            'label_roman_ur' => $field[3],
                            'section' => $field[4],
                            'value_type' => 'number',
                            'unit_type' => 'length',
                            'is_required' => in_array($field[0], $definition['required'], true),
                            'minimum_value_mm' => 10,
                            'maximum_value_mm' => 2500,
                            'sort_order' => $sortOrder,
                        ],
                    );
                }
            }
        });
    }

    /** @return array<int, array<string, mixed>> */
    private function templates(): array
    {
        return [
            [
                'code' => 'mens-shalwar-kameez',
                'name' => "Men's Shalwar Kameez",
                'name_ur' => 'مردانہ شلوار قمیض',
                'name_roman_ur' => 'Mardana Shalwar Kameez',
                'category' => 'shalwar_kameez',
                'description' => 'General-purpose measurements for a men’s shalwar kameez.',
                'required' => ['kameez_length', 'shoulder', 'chest', 'sleeve_length', 'neck', 'shalwar_length'],
                'fields' => [
                    ['kameez_length', 'Kameez length', 'قمیض کی لمبائی', 'Kameez ki lambai', 'upper_garment'],
                    ['shoulder', 'Shoulder', 'تیرا', 'Teera', 'upper_body'],
                    ['chest', 'Chest', 'چھاتی', 'Chhaati', 'upper_body'],
                    ['waist', 'Waist', 'کمر', 'Kamar', 'upper_body'],
                    ['hip', 'Hip', 'ہِپ', 'Hip', 'upper_body'],
                    ['sleeve_length', 'Sleeve length', 'آستین کی لمبائی', 'Aasteen ki lambai', 'sleeves'],
                    ['armhole', 'Armhole', 'تیرا آرم ہول', 'Armhole', 'sleeves'],
                    ['cuff', 'Cuff', 'کف', 'Cuff', 'sleeves'],
                    ['neck', 'Neck', 'گلا', 'Gala', 'upper_garment'],
                    ['shalwar_length', 'Shalwar length', 'شلوار کی لمبائی', 'Shalwar ki lambai', 'lower_garment'],
                    ['shalwar_waist', 'Shalwar waist', 'شلوار کمر', 'Shalwar kamar', 'lower_garment'],
                    ['bottom', 'Bottom', 'پائنچہ', 'Paincha', 'lower_garment'],
                ],
            ],
            [
                'code' => 'womens-shalwar-kameez',
                'name' => "Women's Shalwar Kameez",
                'name_ur' => 'زنانہ شلوار قمیض',
                'name_roman_ur' => 'Zanana Shalwar Kameez',
                'category' => 'shalwar_kameez',
                'description' => 'General-purpose measurements for a women’s shalwar kameez.',
                'required' => ['kameez_length', 'shoulder', 'bust', 'waist', 'hip', 'sleeve_length', 'shalwar_length'],
                'fields' => [
                    ['kameez_length', 'Kameez length', 'قمیض کی لمبائی', 'Kameez ki lambai', 'upper_garment'],
                    ['shoulder', 'Shoulder', 'تیرا', 'Teera', 'upper_body'],
                    ['bust', 'Bust', 'چھاتی', 'Chhaati', 'upper_body'],
                    ['waist', 'Waist', 'کمر', 'Kamar', 'upper_body'],
                    ['hip', 'Hip', 'ہِپ', 'Hip', 'upper_body'],
                    ['sleeve_length', 'Sleeve length', 'آستین کی لمبائی', 'Aasteen ki lambai', 'sleeves'],
                    ['armhole', 'Armhole', 'آرم ہول', 'Armhole', 'sleeves'],
                    ['cuff', 'Cuff', 'کف', 'Cuff', 'sleeves'],
                    ['neck_width', 'Neck width', 'گلے کی چوڑائی', 'Galay ki chorai', 'upper_garment'],
                    ['front_neck_depth', 'Front neck depth', 'سامنے گلے کی گہرائی', 'Samnay galay ki gehrai', 'upper_garment'],
                    ['back_neck_depth', 'Back neck depth', 'پیچھے گلے کی گہرائی', 'Peechay galay ki gehrai', 'upper_garment'],
                    ['shalwar_length', 'Shalwar length', 'شلوار کی لمبائی', 'Shalwar ki lambai', 'lower_garment'],
                    ['bottom', 'Bottom', 'پائنچہ', 'Paincha', 'lower_garment'],
                ],
            ],
            [
                'code' => 'shirt',
                'name' => 'Shirt',
                'name_ur' => 'شرٹ',
                'name_roman_ur' => 'Shirt',
                'category' => 'shirt',
                'description' => 'Core measurements for formal and casual shirts.',
                'required' => ['shirt_length', 'shoulder', 'chest', 'sleeve_length', 'neck'],
                'fields' => [
                    ['shirt_length', 'Shirt length', 'شرٹ کی لمبائی', 'Shirt ki lambai', 'garment'],
                    ['shoulder', 'Shoulder', 'تیرا', 'Teera', 'upper_body'],
                    ['chest', 'Chest', 'چھاتی', 'Chhaati', 'upper_body'],
                    ['waist', 'Waist', 'کمر', 'Kamar', 'upper_body'],
                    ['hip', 'Hip', 'ہِپ', 'Hip', 'upper_body'],
                    ['sleeve_length', 'Sleeve length', 'آستین کی لمبائی', 'Aasteen ki lambai', 'sleeves'],
                    ['cuff', 'Cuff', 'کف', 'Cuff', 'sleeves'],
                    ['neck', 'Neck', 'گلا', 'Gala', 'collar'],
                ],
            ],
            [
                'code' => 'trouser',
                'name' => 'Trouser',
                'name_ur' => 'پتلون',
                'name_roman_ur' => 'Patloon',
                'category' => 'trouser',
                'description' => 'Core measurements for trousers and pants.',
                'required' => ['trouser_length', 'waist', 'hip', 'inseam', 'bottom'],
                'fields' => [
                    ['trouser_length', 'Trouser length', 'پتلون کی لمبائی', 'Patloon ki lambai', 'lengths'],
                    ['waist', 'Waist', 'کمر', 'Kamar', 'body'],
                    ['hip', 'Hip', 'ہِپ', 'Hip', 'body'],
                    ['rise', 'Rise', 'کراس', 'Cross', 'body'],
                    ['thigh', 'Thigh', 'ران', 'Raan', 'leg'],
                    ['knee', 'Knee', 'گھٹنا', 'Ghutna', 'leg'],
                    ['inseam', 'Inseam', 'ان سیم', 'Inseam', 'lengths'],
                    ['bottom', 'Bottom', 'پائنچہ', 'Paincha', 'leg'],
                ],
            ],
            [
                'code' => 'waistcoat',
                'name' => 'Waistcoat',
                'name_ur' => 'واسکٹ',
                'name_roman_ur' => 'Waistcoat',
                'category' => 'waistcoat',
                'description' => 'Core measurements for a tailored waistcoat.',
                'required' => ['waistcoat_length', 'shoulder', 'chest', 'waist'],
                'fields' => [
                    ['waistcoat_length', 'Waistcoat length', 'واسکٹ کی لمبائی', 'Waistcoat ki lambai', 'garment'],
                    ['shoulder', 'Shoulder', 'تیرا', 'Teera', 'upper_body'],
                    ['chest', 'Chest', 'چھاتی', 'Chhaati', 'upper_body'],
                    ['waist', 'Waist', 'کمر', 'Kamar', 'upper_body'],
                    ['hip', 'Hip', 'ہِپ', 'Hip', 'upper_body'],
                    ['neck', 'Neck', 'گلا', 'Gala', 'garment'],
                ],
            ],
        ];
    }

    private function uuid(string $name): string
    {
        return Uuid::uuid5(Uuid::NAMESPACE_URL, "https://tailor.counterpos.pk/measurements/{$name}")->toString();
    }
}
