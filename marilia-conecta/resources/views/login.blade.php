<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
</head>

<body>

    <style>
        * {
            box-sizing: border-box;
            padding: 0;
            margin: 0;
        }

        header {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 25vh;
        }

        main {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 60vh;
        }

        form {
            border: 2px solid #0057A0;
            width: 600px;
            height: auto;
            min-height: 560px;
            border-radius: 10px;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            gap: 10px;
            box-shadow: 0 2px 5px #0057A0;
        }

        form h2{
            margin-bottom: 70px;
            color: #39506C;
            font-size: 30px
        }

        form input {
            width: 500px;
            height: 45px;
            padding: 10px;
            border: 1px solid #0057A0;
            border-radius: 6px;
            box-shadow: 0 2px 2px #0057A0;
            outline: none;
        }

        form button {
            padding: 15px 35px;
            border: none;
            background-color: #0057A0;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            box-shadow: 1px 1px 2px black;
            margin-top: 70px;
        }

        form p{
            font-weight: 600;
            transform: translateY(70px);
        }

        form a{
            color: #39506C;
        }

        .error p{
            color: red
        }

        .success p{
            color: green
        }

        
    </style>
    <header>
        <img src="https://upload.wikimedia.org/wikipedia/commons/2/21/Bras%C3%A3o_de_Mar%C3%ADlia.png" width="200px">
    </header>

    <main>
        <form action="{{ route('login') }}" method="post">
            @csrf
            <h2>Login</h2>

            <input type="text" name="cpf" id="cpf" placeholder="CPF">
            <input type="password" name="password" id="password" placeholder="Senha">

            <button type="submit">Entrar</button>

            <div class="error">
                @if($errors->any)
                <p><strong>{{ $errors->first() }}</strong></p>
                @endif
            </div>

            <div class="success">
                @if(session('success'))
                <p><strong>{{ session('success') }}</strong></p>
                @endif
            </div>

            <p>Ainda não tem uma conta? <a href="{{ route('form.register') }}">Registre-se</a></p>
        </form>



    </main>

</body>

</html>