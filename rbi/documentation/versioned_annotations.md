# Versioned RBI Annotations

Many gems simultaneously maintain more than one version, often with different external APIs. If the gem's RBI
annotation file does not match the version being used in your project, it can result in misleading type checking
errors that slow down development.

Starting in version 0.1.10, the [rbi gem](https://github.com/Shopify/rbi/) supports adding gem version comments
to RBI annotations, allowing us to specify the gem versions that include specific methods and constants.
[Tapioca](https://github.com/Shopify/tapioca) version 0.15.0 and later will strip out any parts of the annotation
file that are not relevant to the current gem version when pulling annotations into a project.

## Syntax

To use this feature, add a comment in the following format directly above a method or constant:

```ruby
# @version > 0.2.0
sig { void }
def foo; end
```

The comment must start with a space, and then the string `@version`, followed by an [operator](#operators) and
a version number. Version numbers must be compatible with Ruby's
[`Gem::Version` specification](https://ruby-doc.org/current/stdlibs/rubygems/Gem/Version.html).

Any method or constant that does not have a version annotation will be considered part of all versions.

## Operators

The following operators are accepted in version comments:

| Symbol | Name  | Notes |
---------------------------------
| =      | Equal  | Only includes the specified gem version |
| !=     | Not equal | Includes all gem versions except the one specified |
| >      | Greater than | Includes all versions greater than the specified version |
| >=     | Greater than or equal to | Includes the specified version and all greater versions |
| <      | Less than | Includes all versions less than the specified version |
| <=     | Less than or equal to | Includes the specified version and all lesser versions |
| ~>     | [Pessimistic operator](https://thoughtbot.com/blog/rubys-pessimistic-operator) | Includes all versions between the specified version and the next version bump |

## Combining Versions

Version comments can use both "AND" and "OR" logic to form more precise version specifications.

### AND

To specify an intersection between multiple version ranges, use a comma-separated list of versions. For example:

```ruby
# version >= 0.3.4, < 0.4.0
sig { void }
def foo; end
```

The example above specifies a version range that starts at version 0.3.4 and includes every version up to 0.4.0.

### OR

To specify a union bewteen multiple version ranges, place multiple version comments in a row above the same method or
constant. For example:

```ruby
# version < 1.4.0
# version >= 4.0.0
sig { void }
def foo; end
```

The example above specifies a version range including any version less than 1.4.0 OR greater than or equal to 4.0.0.
