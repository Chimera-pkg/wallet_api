# lib/latest_stock_price.rb
module LatestStockPrice
    def self.price(symbol)
      # Simulate API request or use any available API
      100.0
    end
  
    def self.prices(symbols)
      symbols.map { |symbol| { symbol: symbol, price: 100.0 } }
    end
  
    def self.price_all
      # Simulate fetching prices for all stocks
      [{ symbol: 'AAPL', price: 150.0 }, { symbol: 'TSLA', price: 700.0 }]
    end
  end
  