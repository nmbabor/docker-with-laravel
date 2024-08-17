@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">{{ __('Dashboard') }}</div>

                <div class="card-body">
                    @if (session('status'))
                        <div class="alert alert-success" role="alert">
                            {{ session('status') }}
                        </div>
                    @endif
                    <div class="flex justify-center">
                        <img width="200px" src="{{asset('storage/assets/lara-docker.png')}}"> 
                    </div>
                    <br />
                    <h1>Laravel Dockerized Project</h1>
                    <p>This project is a Laravel application configured to run in a Dockerized environment. The setup includes Nginx, MySQL, and PHP, managed via Docker Compose.</p>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
