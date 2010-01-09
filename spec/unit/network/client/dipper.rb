#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../../../spec_helper'

require 'puppet/file_bucket/dipper'
describe Puppet::FileBucket::Dipper do
    it "should fail in an informative way when there are failures backing up to the server" do
        File.stubs(:exists?).returns true
        File.stubs(:read).returns "content"

        @dipper = Puppet::FileBucket::Dipper.new(:Path => "/my/bucket")

        filemock = stub "bucketfile"
        Puppet::FileBucket::File.stubs(:new).returns(filemock)
        filemock.expects(:name).returns "name"
        filemock.expects(:save).raises ArgumentError

        lambda { @dipper.backup("/my/file") }.should raise_error(Puppet::Error)
    end

    it "should backup files to a local bucket" do
        @dipper = Puppet::FileBucket::Dipper.new(
            :Path => "/my/bucket"
        )

        File.stubs(:exists?).returns true
        File.stubs(:read).with("/my/file").returns "my contents"

        req = stub "req"
        bucketfile = stub "bucketfile"
        bucketfile.stubs(:name).returns('md5/DIGEST123')
        bucketfile.stubs(:checksum_data).returns("DIGEST123")
        bucketfile.expects(:save).with(req)

        Puppet::FileBucket::File.stubs(:new).with(
            "my contents",
            :bucket_path => '/my/bucket',
            :path => '/my/file'
        ).returns(bucketfile)

        Puppet::Indirector::Request.stubs(:new).with(:file_bucket_file, :save, 'md5/DIGEST123').returns(req)

        @dipper.backup("/my/file").should == "DIGEST123"
    end

    it "should retrieve files from a local bucket" do
        @dipper = Puppet::FileBucket::Dipper.new(
            :Path => "/my/bucket"
        )

        File.stubs(:exists?).returns true
        File.stubs(:read).with("/my/file").returns "my contents"

        bucketfile = stub "bucketfile"
        bucketfile.stubs(:to_s).returns "Content"

        Puppet::FileBucket::File.expects(:find).with(
            'md5/DIGEST123'
        ).returns(bucketfile)

        @dipper.getfile("DIGEST123").should == "Content"
    end

    it "should backup files to a remote server" do
        @dipper = Puppet::FileBucket::Dipper.new(
            :Server => "puppetmaster",
            :Port   => "31337"
        )

        File.stubs(:exists?).returns true
        File.stubs(:read).with("/my/file").returns "my contents"

        req = stub "req"
        bucketfile = stub "bucketfile"
        bucketfile.stubs(:name).returns('md5/DIGEST123')
        bucketfile.stubs(:checksum_data).returns("DIGEST123")
        bucketfile.expects(:save).with(req)

        Puppet::FileBucket::File.stubs(:new).with(
            "my contents",
            :bucket_path => nil,
            :path => '/my/file'
        ).returns(bucketfile)

        Puppet::Indirector::Request.stubs(:new).with(:file_bucket_file, :save, 'https://puppetmaster:31337/production/file_bucket_file/md5/DIGEST123').returns(req)

        @dipper.backup("/my/file").should == "DIGEST123"
    end

    it "should retrieve files from a remote server" do
        @dipper = Puppet::FileBucket::Dipper.new(
            :Server => "puppetmaster",
            :Port   => "31337"
        )

        File.stubs(:exists?).returns true
        File.stubs(:read).with("/my/file").returns "my contents"

        bucketfile = stub "bucketfile"
        bucketfile.stubs(:to_s).returns "Content"

        Puppet::FileBucket::File.expects(:find).with(
            'https://puppetmaster:31337/production/file_bucket_file/md5/DIGEST123'
        ).returns(bucketfile)

        @dipper.getfile("DIGEST123").should == "Content"
    end


end