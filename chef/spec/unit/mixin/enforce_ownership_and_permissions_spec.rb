#
# Author:: Mark Mzyk (<mmzyk@opscode.com>)
# Copyright:: Copyright (c) 2011 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe Chef::Mixin::EnforceOwnershipAndPermissions do

  before(:each) do
    @node = Chef::Node.new
    @node.name "make_believe"
    @run_context = Chef::RunContext.new(@node, {})
    @resource = Chef::Resource::File.new("#{Dir.tmpdir}/madeup.txt")
    @provider = Chef::Provider::File.new(@resource, @run_context)
  end

  it "should call set_all on the file access control object" do
    ::File.should_receive(:exists?).and_return false

    Chef::FileAccessControl.any_instance.should_receive(:set_all)
    @provider.run_action(:create)
  end

  it "should call updated_by_last_action on the new resource" do
    ::File.should_receive(:exists?).and_return false
    Chef::FileAccessControl.any_instance.stub(:set_all)
    @provider.run_action(:create)
    @provider.new_resource.updated_by_last_action?.should be_true

  end

end
