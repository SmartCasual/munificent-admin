module Munificent
  module Admin
    class GamesController < ApplicationController
      load_and_authorize_resource class: "Munificent::Game"

      def index; end
      def show; end
      def new; end
      def edit; end

      def create
        if @game.save
          flash[:notice] = "Game created"
          redirect_to edit_game_path(@game)
        else
          flash[:alert] = @game.errors.full_messages.join(", ")
          redirect_to new_game_path
        end
      end

      def update
        @game.assign_attributes(game_params)

        if @game.save
          flash[:notice] = "Game saved"
        else
          flash[:alert] = @game.errors.full_messages.join(", ")
        end

        redirect_to edit_game_path(@game)
      end

      def destroy
        @game.destroy
        redirect_to games_path
      end

      def csv_upload
        authorize! :manage, Key
      end

      def upload_csv
        authorize! :manage, Key
        params.fetch(:csv).tempfile.each_line do |code|
          resource.keys.create(code: code.chomp)
        end
        redirect_to games_path
      end

    private

      def game_params
        params.require(:game).permit(
          :bulk_key_entry,
          :name,
        )
      end

      def resource
        @game
      end
      helper_method :resource
    end
  end
end
