require "test_helper"

class DestroyTest < ActiveJob::TestCase
  setup do
    clear_db
  end

  test "destroy_async 1" do
    user = User.create(name: "John Doe")
    assert_enqueued_jobs 0
    user.destroy_async
    assert_equal 1, User.count
    assert_enqueued_jobs 1
  end

  test "destroy_async 2" do
    user = User.create(name: "John Doe")
    perform_enqueued_jobs do
      user.destroy_async
    end
    assert_equal 0, User.count
  end

  test "sets custom queue" do
    user = User.create(name: "John Doe")
    user.destroy_async(queue: :test)

    assert_enqueued_with(job: CreateUpdateDestroyAsync::Jobs::Destroy, queue: "test")
  end
end
