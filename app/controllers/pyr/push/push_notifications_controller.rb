module Pyr
  module Push
    class PushNotificationsController < ApplicationController

      respond_to :json

      def create
        #puts "CREATE PUSH PARAMS #{params.inspect}"

        unless current_user.nil?
          Pyr::Push::Device::register(current_user.id, params[:id], Pyr::Push::DEVICE_TYPE_IOS, params)
        end

        render :nothing => true, :status => 201
      end

      def destroy
        #puts "DESTROY PUSH PARAMS #{params.inspect}"

        unless current_user.nil?
          Pyr::Push::Device::unregister(current_user.id, params[:id], Pyr::Push::DEVICE_TYPE_IOS)
        end

        render :nothing => true, :status => 201
      end

    end

  end
end

