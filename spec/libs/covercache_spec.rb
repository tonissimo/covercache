require 'spec_helper'
require 'pp'

describe "covercache" do
  it 'should respond to covers_with_cache' do
    Post.should respond_to(:covers_with_cache)
  end
  it 'should hove class keys storage' do
    pp Post.covercache_keys
    Post.covercache_keys.should be_an(Array)
  end
  it 'should have covercache_model_source attribute' do
    pp Post.covercache_model_source
    Post.covercache_model_source.should be_an(String)
  end
  it 'should have covercache_model_digest attribute' do
    pp Post.covercache_model_digest
    Post.covercache_model_digest.should be_an(String)
  end
  it "should respounds to instance method defined by define_cached" do
    comment = Comment.last
    comment.cached_post.should == comment.post
  end
  it "should respounds to class method defined by define_cached" do
    comments = Comment.cached_for_post(1)
    Post.find(1).comments.should == comments
  end
  it 'should return the same digest for class and instance' do
    post1 = Post.find(1)
    pp post1.covercache_model_digest
    Post.covercache_model_digest.should == post1.covercache_model_digest
  end
  it 'should return the same values with or without cache' do
    test = Post.find(1)
    pp test.inspect
    pp test.cached_comments.inspect
    test.cached_comments.count.should == test.comments.count
  end
end