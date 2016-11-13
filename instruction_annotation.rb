module InstructionAnnotation
  def instructions()
    @instructions_whitelist
  end

  private

  def method_added(m)
    (@instructions_whitelist ||= []).push(m) if @__method_allowed__
    @__method_allowed__ = false
    super
  end

  def vm_instruction()
    @__method_allowed__ = true
  end
end