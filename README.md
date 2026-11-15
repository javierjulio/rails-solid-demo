# Rails Solid Demo: Chat app

This is a simple Chat application to demo Rails' Solid Trifecta: Solid Cable, Solid Cache and Solid Queue.

## Development Setup

- Clone this repository
- Install Ruby with [rbenv](https://github.com/rbenv/rbenv) (see `.ruby-version`)
- Install Node with [nodenv](https://github.com/nodenv/nodenv) (see `.node-version`)
- `bundle install`
- `npm install`
- `bin/rails db:reset`
- `bin/dev`

Open http://localhost:5000 in two browser tabs to test the chat functionality.

### Tests

Run `bin/rails test:all`
