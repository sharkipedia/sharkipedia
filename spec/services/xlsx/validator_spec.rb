require 'rails_helper'

RSpec.describe Xlsx::Validator do
  files = Dir["spec/fixtures/xlsx/**.xlsx"]
  files.each do |file|
    filename = file.split('/').last
    type, valid, _ = filename.split('.').first.split('_')

    context "#{filename}" do
      valid = valid == 'valid'

      subject { described_class.call(file) }

      it "#type = #{type}" do
        expect(subject.type).to be type.to_sym
      end

      it "#valid = #{valid}" do
        expect(subject.valid).to be valid
      end
    end
  end
end
