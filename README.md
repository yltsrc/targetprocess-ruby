# Targetprocess

[![Code Climate]
(https://codeclimate.com/github/Kamrad117/targetprocess-ruby.png)]
(https://codeclimate.com/github/Kamrad117/targetprocess-ruby)

Gem provides ruby interface for interaction with 
[Targetprocess](http://www.targetprocess.com/) through REST api.
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
      config.password = "SECRET"
    end  
    
Do not confuse: 
ACCOUNT - targetprocess.com login;
PASSWORD and USERNAME - your bugtracker's inner ACCOUNT.tpondemand.com credentials.   
    
To check configuration:

    > Targetprocess.credentials #=> 
    #<Targetprocess::Configuration:0x00000004fa7b80
    @domain="http://myacc.tpondemand.com/api/v1/",
    @password="login",
    @username="secret">

###CRUD

Now we support next entities: `UserStory`, `User`, `Task`, `TestCase`, `Project`,
`Release`, `Request`, `Iteration`, `Impediment`, `Feature`, `Comment`, `Bug`.
Others coming soon.
Here you can browse TP's REST CRUD api 
[summary](http://dev.targetprocess.com/blog/2011/09/02/rest-crud-summary-table/)
to find out what fields a required to save new instance or what CRUD operations 
available with current entity.
####Create

    >project = Targetprocess::Project.new(name: "demo project") #=> to create it locally
        <Targetprocess::Project:0x00000002939e58 @name="demo project">
    >project.save #=> to save to remote host
        #<Targetprocess::Project:0x00000002939e58
         @abbreviation="DP",
         @color=nil,
         @company=nil,
         @createdate=2013-07-24 18:19:45 +0300,
         @customfields=[],
         @description=nil,
         @enddate=nil,
         @entitytype={:id=>1, :name=>"Project"},
         @id=367,
         @isactive=true,
         @isproduct=false,
         @lastcommentdate=nil,
         @lastcommenteduser=nil,
         @mailreplyaddress=nil,
         @modifydate=2013-07-24 18:19:45 +0300,
         @name="demo project",
         @numericpriority=12.0,
         @owner={:id=>1, :firstname=>"Administrator", :lastname=>"Administrator"},
         @process={:id=>3, :name=>"Scrum"},
         @program=nil,
         @project=nil,
         @startdate=nil,
         @tags="">
As you can see, some attributes setts by default or calculates with TP's logic.
Also not all of it available to modify.
To find out which attributes are required, or unmodifiable browse this 
[reference](http://md5.tpondemand.com/api/v1/index/meta).


####Read
Gem provides 3 read methods: `.find(id)`, `.all(options={})`, 
`.where(search condition, options={})`
(Yeah, the goal was to make it mostly similar to ActiveRecord).

#####.find(id)
Return instance with specified `:id`.

    > Targetprocess::UserStory.find(160) #=>
         #<Targetprocess::UserStory:0x00000005566ad0
         @id=160,
         @name="Advanced REST API",
         @description=nil,
         @createdate=
          #<DateTime: 2013-05-23T10:00:00+00:00 ((2456436j,36000s,0n),+0s,2299161j)>,
         @customfields=nil,
         @description=nil,
         @effort=14.0,
            . . . .
         @timeremain=0.0,
         @timespent=0.0>

#####.all(options={})

Returns array of instances`(25 by default)`, but you can get more
specifying .all(take: 50). You can not have more then 1000 items per request. 
If you set 'take' parameter greater than 1000, it will be treated as 1000.
If you want to get next 1000 you can specify 'skip' parameter like this:
`Targetprocess::Bug.all({take: 1000, skip: 1000})`

    > Targetprocess::UserStory.all  #=> #return array of (25 by default) UserStories
    > Targetprocess::UserStory.all(take:50) #=> #return array of 50 Userstories
    > Targetprocess::UserStory.all(take:50, skip: 50) #=> #return array of next 50 Userstories
    
#####.where(search_condition, options={})
Return array of filter entities according to specified request. 
You can filter by any of parameters with avaliable matchers:

| Matcher       | Example       | 
| ------------- |:-------------:| 
Equality| Name eq 'My Name'
Not equality|	Name ne 'My Name'
Greater than|	Id gt 5
Greater than or equal|	Project.Id gte 5
Less than|	CreateDate lt '2011-10-01'
Less than or equal|	TimeSpent lte 5.0
In list	|Id in (155,156)
Contains	|Name contains 'rest'
Is null	|Release is null
Is not null|	Description is not null    

    > Targetprocess::Comment.where('general.id eq 182') #=> 
        [#<Targetprocess::Comment:0x00000005658c18
        @id=2,
        @createdate=
        #<DateTime: 2013-07-08T02:36:54+00:00 ((2456482j,9414s,0n),+0s,2299161j)>,
        @description="<div>123</div>\n",
        @general={:id=>182, :name=>"Edit Area 1"},
        @general_id=182,
        @general_name="Edit Area 1",
        @owner={:id=>1, :firstname=>"Administrator", :lastname=>"Administrator"},
        @owner_firstname="Administrator",
        @owner_id=1,
        @owner_lastname="Administrator",
        @parent_id=nil,
        @parentid=nil>]

#####Multiple fields search:
Also you can combine several filtering conditions using operator `and`:

`.where("(createdate gt '2011-01-01') and (enddate lt '2011-02-01')")`

#####Sorting 
You can order the REST API results using any field .
Use 'orderby=field' or 'orderbydesc=field' to sort data ascending or 
descending. For example, this request will return all bugs ordered by 
creation date (recent bugs on top)
    
    Targetprocess::Bug.all(orderbydesc: "creationdate")


####Update
Example:
After you get remote Entity as local instance and modify it, 
you can update remote entity with `#save` method:

    >bug = Targetprocess::Bug.find(123)
    >bug.description = "new description"
    >bug.save
To find out what attributes you can modify browse this 
[reference](http://md5.tpondemand.com/api/v1/index/meta).

####Delete

    >bug  = Targetprocess::Bug.find(347) #=>
        #<Targetprocess::Bug:0x007fccb0739360
         @build=nil,
         @createdate=2013-07-24 17:56:21 +0300,
         @customfields=[],
         @description="something",
            .   .   .   
         @userstory={:id=>234, :name=>"story1"}>
    >bug.delete #=>
        nil
    >Targetprocess::Bug.find(347) #=>
        Targetprocess::NotFound: Bug with Id 347 not found


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
