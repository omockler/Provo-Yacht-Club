require 'rubygems'
require 'sinatra'
require 'erb'
require 'mongo'

include Mongo

configure do
 db = URI.parse(ENV['MONGOHQ_URL'])
 db_name = db.path.gsub(/^\//,'')
 conn = Mongo::Connection.new(db.host, db.port).db(db_name)
 conn.authenticate(db.user, db.password) unless (db.user.nil? || db.password.nil?)
 set :mongo_db, conn
end

get '/' do
	@result = settings.mongo_db["testcollection"]
	@results = @result.find()

	erb :index
 
end

post '/' do
	name = params[:name]
	address = params[:address]
	hospital = params[:hospital]
	city = params[:city]
	state = params[:state]
	zip = params[:zip]
	repunits = params[:repunits]
	actunits = params[:actunits]
	funits = params[:funits]

	coll = settings.mongo_db["testcollection"]
	doc = {"name" => name, "address" => address, "hospital" => hospital, "city" => city, "state" => state, "zip" => zip, "repunits" => repunits, "actunits" => actunits, "funits" => funits, "entrytime" => Time.new.strftime("%I:%M%p %Z on %A, %B %d, %Y")}
	id = coll.insert(doc)

	@result = settings.mongo_db["testcollection"]
	@results = @result.find()

	erb :index
end

# Project todos:
#  *Add Delete Button (db.testcollection.remove( { hospital: "IUPUI" } , 1 )) 
#  *Add Update Button
#  *Sort Abilities
#  *Make Collapsable?
#  *Restyle to Taste (make "in-progress" checkbox which determines color of panel)
#  !!!!Expand to handle recall!!!!


