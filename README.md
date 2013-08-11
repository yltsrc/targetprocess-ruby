# Targetprocess

[![Code Climate]
(https://codeclimate.com/github/Kamrad117/targetprocess-ruby.png)]
(https://codeclimate.com/github/Kamrad117/targetprocess-ruby)
[![Travis CI]
(https://api.travis-ci.org/Kamrad117/targetprocess-ruby.png?branch=master)]
(https://travis-ci.org/Kamrad117/targetprocess-ruby)

Ruby wrapper for [Targetprocess](http://www.targetprocess.com/) JSON REST API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'targetprocess'
```
And then execute:
```bash
$ bundle
```
Or install it yourself as:
```bash
$ gem install targetprocess
```
## Usage

####Configuration
For rails usage you may put following code to 
config/initializers/targetprocess.rb or use anywhere you need it.
```ruby
Targetprocess.configure do |config|
  config.domain = "http://ALIAS.tpondemand.com/api/v1/"
  config.username = "USERNAME"
  config.password = "PASSWORD"
end  
```    
Do not confuse: 
PASSWORD and USERNAME - your bugtracker's inner ALIAS.tpondemand.com credentials.   
    
To check configuration:
```ruby
    > Targetprocess.configuration #=> 
    <Targetprocess::Configuration:0x00000004fa7b80
    @domain="http://myacc.tpondemand.com/api/v1/",
    @password="login",
    @username="secret">
```
###CRUD

Here you can browse TP's REST CRUD api 
[summary](http://dev.targetprocess.com/blog/2011/09/02/rest-crud-summary-table/)
to find out what fields a required to save new instance or what CRUD operations 
available with current entity.

####Create
```ruby
>project = Targetprocess::Project.new(name: "FooBar")        # to create it locally.
 =>    
<Targetprocess::Project:0x007f32a838c228
 @attributes={},
 @changed_attributes={:name=>"FooBar"}>
>project.save          #to save on server.
 => 
<Targetprocess::Project:0x007f32a8918bb0
 @attributes=
  {:id=>3154,
   :name=>"FooBar",
   :description=>nil,
   :start_date=>nil,
   :end_date=>nil,
   :create_date=>2013-08-09 18:43:52 +0300,
   :modify_date=>2013-08-09 18:43:52 +0300,
   :last_comment_date=>nil,
   :tags=>"",
   :numeric_priority=>1579.0,
   :is_active=>true,
   :is_product=>false,
   :abbreviation=>"FOO",
   :mail_reply_address=>nil,
   :color=>nil,
   :entity_type=>{:id=>1, :name=>"Project"},
   :owner=>{:id=>1, :first_name=>"Administrator", :last_name=>"Administrator"},
   :last_commented_user=>nil,
   :project=>nil,
   :program=>nil,
   :process=>{:id=>3, :name=>"Scrum"},
   :company=>nil,
   :custom_fields=>[]},
 @changed_attributes={}>
```

We use simple implementation of "dirty attributes", that means only 
@changed_attributes will be sent to the server. 
As you can see, some attributes setts by default or calculates with TP's logic.
Also not all of it available to modify.
To find out which attributes are required, or unmodifiable browse this 
[reference](http://md5.tpondemand.com/api/v1/index/meta).

Each local instance of TP's entities contains two hashes : 
@attributes and @changed_attributes. 
If some value is in @attributes
hash it means that this value is the same on server.
@changed_attributes, obviously contains values, changed locally.
You can access current value of each hash with the key-named getters
(Setters also provided).

Example of usage:

```ruby
role = Targetprocess::Role.find(1)
=> <Targetprocess::Role:0x8a7cad0
 @attributes={:id=>1, :name=>"Developer", :is_pair=>true, :has_effort=>true}
 @changed_attributes={}>

role.name 
=> "Developer"

role.name = "Programmer"

role
=> <Targetprocess::Role:0x8a7cad0
 @attributes={:id=>1, :name=>"Developer", :is_pair=>true, :has_effort=>true},
 @changed_attributes={:name=>"Programmer"}>
 
role.name = "Developer" 

role
=> <Targetprocess::Role:0x8a7cad0
 @attributes={:id=>1, :name=>"Developer", :is_pair=>true, :has_effort=>true},
 @changed_attributes={}>

role.name = "Programmer" 
=> "Programmer"

role.save       # send changes on server.
=> <Targetprocess::Role:0x8a7cad0  
 @attributes={:id=>1, :name=>"Programmer", :is_pair=>true, :has_effort=>true},
 @changed_attributes={}>
```

####Read
Gem provides 3 read methods: `.find(id, options={})`, `.all(options={})`, 
`.where(search_condition, options={})`
(Yeah, the goal was to make it mostly similar to ActiveRecord).

#####.find(id, options={})
Return instance with specified id. 
```ruby
>project = Targetprocess::Project.find(2) #`http://username:password@account.tpondemand.com/api/v1/Projects/2
=> <Targetprocess::Project:0x007f32a8a9fe48
 @attributes=
  {:id=>2,
   :name=>"Tau Product - Kanban #1",
                .   .   .
   :program=>{:id=>1, :name=>"tauLine #1"},
   :process=>{:id=>2, :name=>"Kanban"},
   :company=>nil,
   :custom_fields=>[]},
 @changed_attributes={}>
```
If you want to learn more about available options - browse this 
[guide](http://dev.targetprocess.com/rest/response_format).
#####.all(options={})

```ruby
Targetprocess::Project.all  # will  make a 
# http://username:password@account.tpondemand.com/api/v1/Projects/?format=json` request, 
# and return an array of Targetprocess::Project instances. 
```
Could be used with options:
```ruby
Targetprocess::Project.all( take: 5, include: "[Tasks]", append: "[Tasks-Count]") 
# will make this request:
# http://kamrad.tpondemand.com/api/v1/projects?format=json&take=5&include=[Tasks]&append=[Tasks-Count]
```    
#####.where(search_condition, options={})
 
```ruby
> Targetprocess::Comment.where('General.Id eq 182') #=> 
#http://username:password@account.tpondemand.com/api/v1/comments?format=json&where=General.Id%20eq%20183
```
You can also use it with options like:
```ruby
Targetprocess::Comment.where('General.Id eq 182', take: 1)
# http://username:password@account.tpondemand.com/api/v1/comments?format=json&where=General.Id%20eq%20182&take=1
```
####Update

`#save` method also can be used for updating remote entity.  
Remember that all attributes in @changed_attributes still not updated on 
server.
After you get remote entity as local instance and modify it, 
you can update remote entity with `#save` method:

Example:
```ruby    
>bug = Targetprocess::Bug.find(123)
>bug.description = "new description"
>bug.save
```    
To find out what attributes you can modify browse this 
[reference](http://md5.tpondemand.com/api/v1/index/meta).

####Delete

##### #delete
Just call it on entity and...it's gone!
```ruby
>bug  = Targetprocess::Bug.find(347)      
>bug.delete #=> true 
>Targetprocess::Bug.find(347) #=>  will raise Targetprocess::NotFound error
```

###Metadata
##### #meta
To get metadata of entity use `#meta`:
```ruby
Targetprocess::Userstory.meta
# will make a http://tpruby.tpondemand.com/api/v1/userstories/meta?format=json request.
```

####Errors
    
    ConfigurationError
    APIError
    |-BadRequest
    |-NotFound 
    |-MethodNotAllowed
    |-InternalServerError

You can catch APIError or a specific type of error.

Example:
```ruby
begin
  Targetprocess::Project.all
resque Targetprocess::APIError  #or Targetprocess::APIError::NotFound
  #something awesome
end
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
