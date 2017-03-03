require 'csv'
class UploadsController < ApplicationController

  def create
    data = CSV.read(params["csv"].path)
    begin
      if params["data_type"] == "User"
        upload_to_users(data, params["override"].present?)
      elsif params["data_type"] == "LISP"
        upload_to_lisps(data, params["override"].present?)
      end
    rescue => e
      redirect_to '/clients/1#',  :flash => {:error => e.message}
      return
    end

    redirect_to '/clients/1#',  :flash => {:notice => "Successfully uploaded data"}
  end

  def upload_to_users(data, override = false)
    if validate_headers_users(data.first)
      data.delete_at(0)
      data.each do |x|
        begin
          if not_nil_user(x)
            u = User.find_by_name(x[0])
            if u.present?
              if override
                u.employee_id = x[1]
                u.email = x[2]
                u.phone_number = x[3]
                u.role_type = x[4]
                u.approver_type = x[5]
                if current_user.client_id?
                  u.client_id = current_user.client_id
                else
                  u.client_id = Client.first.id
                end
                sg = Subgroup.find_by_name(x[6])
                u.subgroup = sg if sg.present?
                u.save
              end
            else

              u = User.new(:name => x[0],
                :employee_id => x[1],
                :email => x[2],
                :phone_number => x[3],
                :role_type => x[4],
                :approver_type => x[5])
              sg = Subgroup.find_by_name(x[6])
              u.subgroup = sg
              if current_user.client_id?
                u.client_id = current_user.client_id
              else
                u.client_id = Client.first.id
              end
              u.save
              u.notify
            end
          end
        rescue => e
          Rails.logger("unable to update #{x[0]}")
          next
        end
      end
    else
      raise "Invalid column headers"
    end
  end

  def upload_to_lisps(data, override = false)
    if validate_headers_lisps(data.first)
      data.delete_at(0)
      data.each do |x|
        begin
          if not_nil_lisp(x)
            u = Lisp.find_by_name(x[0])
            if u.present?
              if override
                u.code = x[1]
                u.zone = x[2]
                u.state = x[3]
                u.city = x[4]
                u.save
              end
            else
              u = Lisp.new(:name => x[0],
                :code => x[1],
                :zone => x[2],
                :state => x[3],
                :city => x[4])
              u.save
            end
          end
        rescue => e
          Rails.logger("unable to update lisp #{x[0]}")
          next
        end
      end
    else
      raise "Invalid column headers"
    end
  end

  def not_nil_user(row)
    row[0].present? and row[1].present? and row[2].present? and 
    row[3].present? and row[4].present? and row[5].present? and
    row[6].present?
  end

  def not_nil_lisp(row)
    row[0].present? and row[1].present? and row[2].present? and 
    row[3].present? and row[4].present?
  end

  def validate_headers_users(head)
    head[0].downcase == "name" and
    head[1].downcase == "eid" and    
    head[2].downcase == "email" and
    head[3].downcase == "phone" and
    head[4].downcase == "type" and
    head[5].downcase == "approvertype" and
    head[6].downcase == "subgroup"
  end

  def validate_headers_lisps(head)
    head[0].downcase == "name" and
    head[1].downcase == "code" and    
    head[2].downcase == "zone" and
    head[3].downcase == "state" and
    head[4].downcase == "city"
  end

end