class User < ApplicationRecord
  has_many :events, dependent: :destroy
  has_many :event_registrations, dependent: :destroy
  has_many :registered_events, through: :event_registrations, source: :event
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :family, optional: true # Important car la création de l'user se fait avant la famille.
  enum status: { member: "member", helper: "helper" }
  has_many :tasks, dependent: :destroy
  has_many :documents, dependent: :nullify
  has_many :chats, dependent: :destroy

  # Sert à pouvoir faire current_user.member? ou .helper? plus tard dans les autorisations etc
  def member?
    status == "member"
  end

  def helper?
    status == "helper"
  end

end
