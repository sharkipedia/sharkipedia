require 'rails_helper'

RSpec.describe Xlsx::Validator do
  files = Dir["spec/fixtures/xlsx/**.xlsx"]
  files.each do |file|
    next if file =~ /~\$/

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

  context 'invalid file' do
    file = 'docs/erd.pdf'
    subject { described_class.call(file) }

    it "#type = invalid" do
      expect(subject.type).to be :invalid
    end

    it "#valid = false" do
      expect(subject.valid).to be false
    end
  end
end
