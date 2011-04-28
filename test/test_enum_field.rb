require 'helper'

class MockedModel; include EnumField; end;

class TestEnumField < Test::Unit::TestCase
  context "with a simple gender enum on Person model" do  
    should "create constant with possible values named as pluralized field" do
      assert_equal %w(Male Female), Person::GENDERS
    end
    
    should "create a constant for each value" do
      assert_equal "Male", Person::MALE
    end
    
    should "create query methods for each enum type" do
      model = Person.create(:gender => "Male")
      assert model.male?
      assert !model.female?
      
      model.update_attribute(:gender, "Female")
      assert !model.male?
      assert model.female?
    end
    
    should "extend active record base with method" do
      assert_respond_to ActiveRecord::Base, :enum_field
    end
    
    should "fail validation" do
      model = Person.new(:gender => "both")
      assert !model.valid?
      
      model.gender = nil
      assert !model.valid?
    end
  end

  context "With an enum containing multiple word choices" do
    setup do
      MockedModel.stubs(:validates_inclusion_of)
      MockedModel.send :enum_field, :field, ['choice one', 'choice-two', 'other']
      @model = MockedModel.new
    end

    should "define an underscored query method for the multiple word choice" do
      assert_respond_to @model, :choice_one?
    end

    should "define an underscored query method for the dasherized choice" do
      assert_respond_to @model, :choice_two?
    end
  end

  context "With an enum containing mixed case choices" do
    setup do
      MockedModel.stubs(:validates_inclusion_of)
      MockedModel.send :enum_field, :field, ['Choice One', 'ChoiceTwo', 'Other']
      @model = MockedModel.new
    end

    should "define a lowercase, underscored query method for the multiple word choice" do
      assert_respond_to @model, :choice_one?
    end

    should "define a lowercase query method for the camelcase choice" do
      assert_respond_to @model, :choicetwo?
    end
  end
  
  context "With an enum containing invalid characters" do
    should "thow an exception if invalid characters are passed in" do
      assert_raises ArgumentError do
        MockedModel.send :enum_field, :field, [ '*&%^%?!' ]
      end
    end
  end
  
  context "With a prefix option" do
    setup do
      MockedModel.stubs(:validates_inclusion_of)
    end
    
    should "define prefixed query methods" do
      MockedModel.send :enum_field, :gender, ['Male', "Female"], :prefix => true
      @model = MockedModel.new
      assert_respond_to @model, :gender_male?
    end
    
    should "define custom prefixed query methods" do
      MockedModel.send :enum_field, :gender, 
        ['Male', "Female"], :prefix => 'sex'
        
      @model = MockedModel.new
      assert_respond_to @model, :sex_male?
    end
  end
end

