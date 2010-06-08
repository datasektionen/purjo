class KthAccountsController < ApplicationController
  require_role 'admin'
  # GET /kth_accounts
  # GET /kth_accounts.xml
  def index
    @kth_accounts = KthAccount.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @kth_accounts }
    end
  end

  # GET /kth_accounts/1
  # GET /kth_accounts/1.xml
  def show
    @kth_account = KthAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @kth_account }
    end
  end

  # GET /kth_accounts/new
  # GET /kth_accounts/new.xml
  def new
    @kth_account = KthAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @kth_account }
    end
  end

  # GET /kth_accounts/1/edit
  def edit
    @kth_account = KthAccount.find(params[:id])
  end

  # POST /kth_accounts
  # POST /kth_accounts.xml
  def create
    @kth_account = KthAccount.new(params[:kth_account])

    respond_to do |format|
      if @kth_account.save
        flash[:notice] = 'KthAccount was successfully created.'
        format.html { redirect_to(@kth_account) }
        format.xml  { render :xml => @kth_account, :status => :created, :location => @kth_account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @kth_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /kth_accounts/1
  # PUT /kth_accounts/1.xml
  def update
    @kth_account = KthAccount.find(params[:id])

    respond_to do |format|
      if @kth_account.update_attributes(params[:kth_account])
        flash[:notice] = 'KthAccount was successfully updated.'
        format.html { redirect_to(@kth_account) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @kth_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /kth_accounts/1
  # DELETE /kth_accounts/1.xml
  def destroy
    @kth_account = KthAccount.find(params[:id])
    @kth_account.destroy

    respond_to do |format|
      format.html { redirect_to(kth_accounts_url) }
      format.xml  { head :ok }
    end
  end
end
