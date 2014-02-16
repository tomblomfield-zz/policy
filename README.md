# Policy

Simple Ruby Gem that implements Policies in Ruby - an object-oriented
approach to controller permissioning.

## Usage

### Installation

```ruby
gem install policy
````

### Define a Policy

```ruby
class HasCreditCard
  include Policy::PolicyObject

  def perform
    fail!("Credit card required") if user.credit_card.nil?
  end
end
```

### Implement in a controller

```ruby
class CheckoutController

  policy :has_credit_card, user: current_user

  ...

end
```

### Advanced Options

#### Target certain controller actions


```ruby
class CheckoutController

  policy :has_credit_card, user: current_user, only: [:new, :create]

  ...

end
```

#### Custom Error Methods

By default, on failure Policy will respond to an HTML format request with redirect :back and set a flash notice.
It will respond to json with

```ruby
{ status: :unauthorized, errors: ["Your error message"] }
```

You can override the `unauthorized` method to respond however you like:

```ruby
class CheckoutController

  policy :has_credit_card, user: current_user, only: [:new, :create]

  ...

  private

  def unauthorized(message)
    redirect_to :home_path, notice: message
  end

end
```

#### Use Policy Outside a Controller

You can initialize a policy object by calling `perform`

```ruby
can_edit = CanEditPolicy.perform(user: current_user)
link_to "Edit Me", edit_path if can_edit.allowed?
```


### Contributions

Contributions welcome! Please fork the project and open a pull request.