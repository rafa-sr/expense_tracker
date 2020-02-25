require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
  RSpec.describe API do
    include Rack::Test::Methods

  def app
    API.new(ledger: ledger)
  end


    let(:ledger)  { instance_double('ExpenseTracker::Ledger') }
    let(:last_response_to_json) { JSON.parse(last_response.body) }


    describe 'POST /expenses' do

      let(:expense) {{ 'some' => 'data'}}

      context 'when expenses is successfully recorded' do

        before do
          allow(ledger).to receive(:record)
                               .with(expense)
                               .and_return(RecordResult.new(true,417,nil))
        end

        it 'returns the expenses id' do
          post '/expenses', JSON.generate(expense)


          expect(last_response_to_json).to include('expense_id' => 417)
        end

        it 'responds with 200 (ok)' do
          post '/expenses', expense.to_json

          expect(last_response.status).to eq(200)
        end
      end

      context 'when expenses fail validations' do

        before do
          allow(ledger).to receive(:record)
                               .with(expense)
                               .and_return(RecordResult.new(false,417,'Expense incomplete'))
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)

          expect(last_response_to_json).to include('error' =>'Expense incomplete')
        end

        it 'responds with 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)

          expect(last_response.status).to eq(422)
        end
      end

    end
  end
end