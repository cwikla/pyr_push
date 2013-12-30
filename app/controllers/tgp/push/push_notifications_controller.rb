module Tgp
  module Push
    class PushNotificationsController < ApplicationController

      respond_to :json

      def create
        #puts "CREATE PUSH PARAMS #{params.inspect}"

        Tgp::Push::Device::register(current_user.id, params[:id], Tgp::Push::DEVICE_TYPE_IOS, params)

        render :nothing => true, :status => 201
      end

      def destroy
        #puts "DESTROY PUSH PARAMS #{params.inspect}"

        Tgp::Push::Device::unregister(current_user.id, params[:id], Tgp::Push::DEVICE_TYPE_IOS)

        render :nothing => true, :status => 201
      end

    end

  end
end

