require 'test_helper'

class StudyGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @study_group = study_groups(:one)
  end

  test "should get index" do
    get study_groups_url, as: :json
    assert_response :success
  end

  test "should create study_group" do
    assert_difference('StudyGroup.count') do
      post study_groups_url, params: { study_group: { course_id: @study_group.course_id, description: @study_group.description, title: @study_group.title, user_id: @study_group.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show study_group" do
    get study_group_url(@study_group), as: :json
    assert_response :success
  end

  test "should update study_group" do
    patch study_group_url(@study_group), params: { study_group: { course_id: @study_group.course_id, description: @study_group.description, title: @study_group.title, user_id: @study_group.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy study_group" do
    assert_difference('StudyGroup.count', -1) do
      delete study_group_url(@study_group), as: :json
    end

    assert_response 204
  end
end
