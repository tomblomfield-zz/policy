# Policy

Simple implementation of Policies in Ruby - an object-oriented approach to
controller permissioning.

## Usage

### Installation

```ruby
gem install policy
````

If you want to use the library with Rails:

```ruby

class ApplicationController < ActionController::Base
  include Policy::PolicyBehaviour
end
```

### Define a Policy

Policy is focused around Policy Objects. By default, you should put these
classes in `app/policies` and they should end with `Policy`

```ruby
class HasCreditCardPolicy
  include Policy::PolicyObject

  def perform
    fail!("Credit card required") if current_user.credit_card.nil?
  end
end
```

### Implement in a controller

```ruby
class CheckoutController

  policy(:has_credit_card) {{ member: current_member }}

  ...

end
```

If the Policy is failed, the `unauthorized` will be called on the controller -
by default this will `redirect_to :back` and set a flash error, but this can
be customised

### Advanced Options

#### Target certain controller actions


```ruby
class CheckoutController

  policy(:has_credit_card, only: [:new, :create]) {{ member: current_member }}

  ...

end
```

#### Custom Unauthorized Methods

By default, on failure Policy will respond to an HTML format request with
`redirect_to :back` and set a flash error.

It will also respond to json with:
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
    redirect_to home_path, notice: message
  end

end
```


#### Use Policy Outside a Controller

You can initialize a policy object anywhere in your application by calling
`perform`

```ruby
can_edit = CanEditPolicy.perform(user: current_user)
link_to "Edit Me", edit_path if can_edit.allowed?
```


### Contributions

Contributions welcome! Please fork the project and open a pull request.