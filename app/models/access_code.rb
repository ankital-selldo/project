class AccessCode

  ADMIN_CODE = "ADMIN_SECRET_2025"
  CLUB_HEAD_CODE = "CLUB_HEAD_2025"

  def self.verify_admin_code(code)
    code == ADMIN_CODE
  end

  def self.verify_club_head_code(code)
    code == CLUB_HEAD_CODE
  end
end