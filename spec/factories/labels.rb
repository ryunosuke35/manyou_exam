FactoryBot.define do
  factory :label do
    name { 'ラベル1' }
  end
  factory :second_label, class: Label do
    name { 'ラベル2' }
  end
  factory :third_label, class: Label do
    name { 'ラベル3' }
  end
end
