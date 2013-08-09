# Targetprocess

[![Code Climate]
(https://codeclimate.com/github/Kamrad117/targetprocess-ruby.png)]
(https://codeclimate.com/github/Kamrad117/targetprocess-ruby)
[![Travis CI]
(https://api.travis-ci.org/Kamrad117/targetprocess-ruby.png?branch=master)]
(https://travis-ci.org/Kamrad117/targetprocess-ruby)

Ruby wrapper for [Targetprocess](http://www.targetprocess.com/) REST API.
In development now!
## Installation

Add this line to your application's Gemfile:

    gem 'targetprocess'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install targetprocess

## Usage

####Configuration
For rails usage you may put following code to 
config/initializers/targetprocess.rb or use anywhere you need it.

    Targetprocess.configure do |config|
      config.domain = "http://ACCOUNT.tpondemand.com/api/v1/"
      config.username = "USERNAME"
      config.password = "PASSWORD"
    end  
    
Do not confuse: 
ACCOUNT - targetprocess.com login;
PASSWORD and USERNAME - your bugtracker's inner ACCOUNT.tpondemand.com credentials.   
    
To check configuration:

    > Targetprocess.configuration #=> 
    #<Targetprocess::Configuration:0x00000004fa7b80
    @domain="http://myacc.tpondemand.com/api/v1/",
    @password="login",
    @username="secret">

###CRUD

Here you can browse TP's REST CRUD api 
[summary](http://dev.targetprocess.com/blog/2011/09/02/rest-crud-summary-table/)
to find out what fields a required to save new instance or what CRUD operations 
available with current entity.

####Create

    >project = Targetprocess::Project.new(name: "FooBar") #=> to create it locally
        #<Targetprocess::Project:0x007f32a838c228
        @attributes={},
        @changed_attributes={:name=>"FooBar"}>
    >project.save #=> to save to remote host
    => #<Targetprocess::Project:0x007f32a8918bb0
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

We use simple implementation of "dirty attributes", that means that only changed
attributes will sending to server. 
As you can see, some attributes setts by default or calculates with TP's logic.
Also not all of it available to modify.
To find out which attributes are required, or unmodifiable browse this 
[reference](http://md5.tpondemand.com/api/v1/index/meta).


####Read
Gem provides 3 read methods: `.find(id)`, `.all(options={})`, 
`.where(search_condition, options={})`
(Yeah, the goal was to make it mostly similar to ActiveRecord).

#####.find(id)
Return instance with specified id. 

    >project = Targetprocess::Project.find(2) #`http://username:password@account.tpondemand.com/api/v1/Projects/2
    => #<Targetprocess::Project:0x007f32a8a9fe48
     @attributes=
      {:id=>2,
       :name=>"Tau Product - Kanban #1",
                    .   .   .
       :program=>{:id=>1, :name=>"tauLine #1"},
       :process=>{:id=>2, :name=>"Kanban"},
       :company=>nil,
       :custom_fields=>[]},
     @changed_attributes={}>


#####.all(options={})

`Targetprocess::Project.all` make a 
`http://username:password@account.tpondemand.com/api/v1/Projects/?format=json` request, 
and return an array of Targetprocess::Project instances. 

Could be used with options:

    Targetprocess::Project.all( take: 5, include: "[Tasks]", append: "[Tasks-Count]") 
    # make this request:
    http://kamrad.tpondemand.com/api/v1/projects?format=json&take=5&include=[Tasks]&append=[Tasks-Count]
    # and return array of Targetprocess::Project instances.
    
#####.where(search_condition, options={})
 

    > Targetprocess::Comment.where('General.Id eq 182') #=> 
    http://username:password@account.tpondemand.com/api/v1/comments?format=json&where=General.Id%20eq%20183
    
You can also use it with options like:

    Targetprocess::Comment.where('General.Id eq 182', take: 1)
    #=>
    http://username:password@account.tpondemand.com/api/v1/comments?format=json&where=General.Id%20eq%20182&take=1

####Update

###### `#save`
Example:
After you get remote Entity as local instance and modify it, 
you can update remote entity with `#save` method:

    >bug = Targetprocess::Bug.find(123)
    >bug.description = "new description"
    >bug.save
    
To find out what attributes you can modify browse this 
[reference](http://md5.tpondemand.com/api/v1/index/meta).

####Delete

##### `#delete`

    >bug  = Targetprocess::Bug.find(347)      
    >bug.delete #=> true 
    >Targetprocess::Bug.find(347) #=>  will raise Targetprocess::NotFound error


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
