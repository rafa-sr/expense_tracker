require_relative '../../../app/ledger'
require_relative '../../../config/sequel'
require_relative '../../support/db'

module ExpenseTracker
  RSpec.describe Ledger, :aggregate_failures, :db do
    let (:ledger) { Ledger.new}
    let (:expense) do
      {
        payee: 'Starbucks',
        amount: 5.75,
        date: '2017-06-10'
      }
    end

    describe '#record' do
      context 'with a valid expense' do
        it 'successfully save the expense in the DB' do
          result = ledger.record(expense)

          expect(result).to  be_success
          expect(DB[:expenses].all).to match [a_hash_including(
                                                id: result.expense_id,
                                                payee: expense[:payee],
                                                amount: expense[:amount],
                                                date: Date.iso8601('2017-06-10')
                                              )]
        end
      end
    end

    context 'when expense lacks a payee' do
      it 'rejects the expense as invalid' do
        expense.delete(:payee)
        result = ledger.record(expense)

        expect(result).not_to be_success
        expect(result.expense_id).to be nil
        expect(result.error_message).to include('payee is required')
        expect(DB[:expenses].count).to eq 0
      end

    end
  end
end
