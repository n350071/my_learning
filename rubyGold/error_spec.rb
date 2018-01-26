describe 'Exception' do
  example 'classes' do
    error_box = []
    error_msg = []
    standard_errors = [StandardError,ArgumentError,RuntimeError,NameError,NoMethodError,ZeroDivisionError]
    standard_errors.each{|error|
      begin
        raise error.exception("#{error}が発生しました")
      rescue NoMethodError => e #<NameError
        error_box << NoMethodError
        error_msg << e.message

      rescue NameError => e #<StandardError
        error_box << NameError
        error_msg << e.message
      rescue ZeroDivisionError => e #<StandardError
        error_box << ZeroDivisionError
        error_msg << e.message
      rescue RuntimeError => e #<StandardError
        error_box << RuntimeError
        error_msg << e.message
      rescue ArgumentError => e #<StandardError
        error_box << ArgumentError
        error_msg << e.message

      rescue StandardError => e #<Exception
        error_box << StandardError
        error_msg << e.message
      end
    }
    expect(error_box).to eq standard_errors
    expect(error_msg).to eq standard_errors.map{|obj| obj.to_s + "が発生しました"}
  end
  example 'exit' do
    str = ""
    begin
      exit
    rescue SystemExit
      str << "SystemExit."
    else
      str << "else."
    ensure
      str << "ensure."
    end
    expect(str).to eq "SystemExit.ensure."
  end
end
