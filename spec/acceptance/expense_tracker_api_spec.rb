require_relative '../../app/api.rb'
require 'rack/test'
require 'json'

def app
  ExpenseTracker::API.new
end

module ExpenseTracker
  RSpec.describe 'Expense Tracker API' do
    include Rack::Test::Methods

    def post_expenses(expenses)
      post '/expenses', JSON.generate(expenses)
      #eq es le matcher
      expect(last_response.status).to(eq(200))
      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' =>  a_kind_of(Integer) )
      expenses.merge('id' => parsed['expense_id'])
    end

    it 'records submitted expenses' do
      pending 'need to persist expenses'
      coffee = post_expenses(
          'payee'   =>    'Starckbucks',
          'Amount'  => '5.75',
          'date'    =>'2017-06-10'
      )

      zoo = post_expenses(
          'payee'   => 'zoo',
          'mount'   => 15.25,
          'date'    => '2007-06-10'
      )

      groceries = post_expenses(
          'payee'   => 'whole_foods',
          'mount'   => 95.20,
          'date'    => '2007-06-11'
      )

      get 'expenses/2017-06-10'
      expect(last_response.status).to eq(200)
      expeneses = JSON.parse(last_response.body)
                            #check that array contains 2 expeneses, no matter the other
                            # it can be done wit eq[coffee,zoo] if the order matters
      expect(expeneses).to contain_exactly(coffee,zoo)
    end
  end
end