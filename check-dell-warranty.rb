#!/usr/bin/env ruby
# title:  check-dell-warranty.rb
# descr:  gets expiration dates for one or more service tags
# author: andrew o'neill
# date:   2016

require 'net/http'
require 'json'
require 'date'
require 'colorize'

# enter your dell api key here
@apikey = ''

# look up the service tag via dell's api
def get_expiration(svctag)
  exp_date = nil
  uri = URI("https://sandbox.api.dell.com/support/assetinfo/v4/getassetwarranty/#{svctag}?apikey=#{@apikey}")
  res = Net::HTTP.get_response(uri)
  
  if res.code != '200'
    puts "Call to Dell API for #{svctag} failed: #{res.message}"
    exit 1
  end
  
  json = JSON.parse(res.body)
  description = json['AssetWarrantyResponse'][0]['AssetHeaderData']['MachineDescription']
  json['AssetWarrantyResponse'][0]['AssetEntitlementData'].each do |w|
    if w['EntitlementType'].downcase == 'extended' && ( w['ServiceLevelCode'].downcase == 'nd' || w['ServiceLevelCode'].downcase == 'np' )
      exp_date = Date.parse(w['EndDate']).strftime("%m/%d/%Y")
      break
    # recently purchased hardware doesn't have an extended entitlement just yet  
    elsif w['EntitlementType'].downcase == 'initial' && ( w['ServiceLevelCode'].downcase == 'nd' || w['ServiceLevelCode'].downcase == 'np' )
      exp_date = Date.parse(w['EndDate']).strftime("%m/%d/%Y")
      break
    else
      next
    end
  end

  if ! exp_date.nil?
    if Date.strptime(exp_date, '%m/%d/%Y') >= Date.today
      exp_date = exp_date.green
    else
      exp_date = exp_date.red
    end
    return "#{exp_date} -- #{description}"
  else
    return "Unable to determine expiration date"
  end
end
  
# make sure that something is being passed in
if ARGV.empty?
  puts "usage: $ ./check-dell-warranty.rb <service tag 1> [service tag N] ..."
  exit 1
end

# run through each service tag passed in
ARGV.each do |svctag|
  puts "#{svctag}: #{get_expiration(svctag)}"
end
