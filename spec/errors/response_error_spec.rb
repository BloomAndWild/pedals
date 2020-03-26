# frozen_string_literal: true

require 'spec_helper'

describe Pedals::Errors::ResponseError do
  let(:response_json) { double(body: { message: "Unprocessable Entity" }.to_json, status: 422) }
  let(:response_text) { double(body: "Oops, bad request", status: 500) }

  subject { described_class }

  describe "#status" do
    context 'bad http response with 422 error and json body' do
      it 'has status of http error code' do
        expect(subject.new(response_json).status).to eq 422
      end
    end

    context 'bad http response with 500 error and text body' do
      it 'has status of http error code' do
        expect(subject.new(response_text).status).to eq 500
      end
    end
  end

  describe "#body" do
    context 'bad http response with 422 error and json body' do
      it 'has the same body as the original error' do
        expect(subject.new(response_json).body).to eq response_json.body
      end
    end

    context 'bad http response with 500 error and text body' do
      it 'has the same body as the original error' do
        expect(subject.new(response_text).body).to eq response_text.body
      end
    end
  end

  describe "#response_error" do
    context 'bad http response with 422 error and json body' do
      it 'has the original error message' do
        expect(subject.new(response_json).response_error).to eq "Unprocessable Entity"
      end
    end

    context 'bad http response with 500 error and text body' do
      it 'has the default error message' do
        expect(subject.new(response_text).response_error)
          .to eq Pedals::Errors::ResponseError::DEFAULT_MESSAGE
      end
    end
  end
end
