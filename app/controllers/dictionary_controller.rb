require 'httpclient'
require 'rexml/document'
include REXML

class DictionaryController < ApplicationController
  def list
    render :xml => Dictionary::XML 
  end

  def driver_add
    dict = Dictionary.get_dictionary()
    dict.driver_add(params[:xml])
    Log.log(session[:user], "添加驱动")
    render :text => 'ok'
  end

  def driver_update
    dict = Dictionary.get_dictionary()
    dict.driver_update(params[:id], params[:field], params[:value])
    Log.log(session[:user], "修改驱动")
    render :text => 'ok'
  end

  def add
    dict = Dictionary.get_dictionary()
    dict.add(params[:category], params[:xml])
    Log.log(session[:user], "添加字典信息")
    render :text => 'ok'
  end

  def update
    dict = Dictionary.get_dictionary()
    dict.update(params[:category], params[:id], params[:value])
    Log.log(session[:user], "修改字典信息")
    render :text => 'ok'
  end
end
