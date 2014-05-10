#!/usr/bin/env perl

### 道路の雨情報をとってくる

use strict;
use utf8;
use File::Spec;
use File::Basename 'dirname';
use lib (
    File::Spec->catdir(dirname(__FILE__), qw|.. lib|), 
);
use Rainview;
use Rainview::Crawler;

my $run_env     = $ENV{PLACK_ENV} eq 'development' ? 'local' : $ENV{PLACK_ENV};
my $basedir     = File::Spec->catdir(dirname(__FILE__), '..');
my $config_file = File::Spec->catfile($basedir, 'config', $run_env.'.pl');
my $config      = require($config_file);

Rainview->run(%$config);
my $c = Rainview->c;
my $db = $c->db;

my @urls = qw|
    http://its.cbr.mlit.go.jp/TkyDsp.exe?FNo=4&GNo=4&&
    http://www.road.ktr.mlit.go.jp/info/uryo/all/all.html
|;

for my $url (@urls) {
    crawl($url);
}

sub crawl {
    my $url = shift;
    my $crawler = Rainview::Crawler->new;
    $crawler->url($url); 
    
    my @points = $crawler->crawl;
    my $routes = {};
    
    for my $point (@points) {
        my $route_name = $point->{route};
    
        $routes->{$route_name} ||= 
            $db->single(route => {name => $route_name}) || 
            $db->insert(route => {name => $route_name, created_at => $c->now->strftime('%Y-%m-%d %H:%M:%S')})
        ;
        my $route = $routes->{$route_name};
    
        $point->{route_id} = $route->{id};
        delete $point->{route};
    
        my $cond = {name => delete $point->{name}};
    
        my $res = $db->update(point => $point, $cond);
        if ($res eq '0E0') {  ### レコード数がない
            my $data = { %$point, %$cond, created_at => $c->now->strftime('%Y-%m-%d %H:%M:%S') };
            $db->insert(point => $data);
        }
    }
}
