<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
</head>

<body>

    <style>
        * {
            box-sizing: border-box;
            padding: 0;
            margin: 0;
        }

        body {
            line-height: 2;
            font-family: 'Lucida Sans', 'Lucida Sans Regular', 'Lucida Grande', 'Lucida Sans Unicode', Geneva, Verdana, sans-serif
        }

        main {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            padding: 60px;
            width: 100%;
        }

        .container {
            width: 100%;
            max-width: 500px;
            background-color: #fff;
            box-shadow: 0px 2px 3px #0057A0;
            min-height: 150px;
            height: auto;
            margin: 40px auto;
            border-radius: 8px;
            padding: 20px;
            border-left: 6px solid #0057A0;

        }

        button {
            padding: 10px 15px;
            border-radius: 8px;
            background-color: #0057A0;
            color: #fff;
            font-weight: 600;
            border: none;
            margin-top: 20px;
            cursor: pointer;
        }

        .modal {
            display: none;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
            position: fixed;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
        }

        .modal-content {
            background-color: #fff;
            width: 100%;
            max-width: 600px;
            height: auto;
            min-height: 600px;
            margin: 5% auto;
            padding: 20px;
            border-radius: 10px;
            line-height: 1.5;
            overflow-y: auto;
            box-shadow: 1px 1px 10px;
        }

        .container strong {
            color: #39506C;
        }

        .modal-content p {
            line-height: 2;
        }

        .modal-content label {
            display: block;
            font-weight: bold;
            color: #0057A0;
            ;
        }

        .modal-content form {
            margin-top: 10px;
        }

        .modal-content select {
            width: 90%;
            height: 40px;
            border-radius: 8px;
            border: 1px solid #0057A0;
            padding: 4px;
            outline: none;
            font-weight: 600;
        }

        .modal-content textarea {
            width: 90%;
            height: 40px;
            border-radius: 8px;
            border: 1px solid #0057A0;
            padding: 10px;
            outline: none
        }

        .user-info {
            margin-top: 30px;
            background-color: rgb(243, 244, 245);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 45px;
            border-radius: 5px;
            border-left: 5px solid #0057A0;
        }

        .divisoria {
            color: #0057A0;
            font-weight: bold;
            font-size: 20px;
        }

        .close {
            font-size: 25px;
            cursor: pointer;
        }

        img {
            border-radius: 10px;
            margin: 10px 0;
        }

        header {
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #0057A0;
            color: #fff;
            height: 70px;
        }

        .status-badge {
            padding: 4px 8px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 700;
            text-transform: uppercase;

        }

        .status-Aberto {
            background-color: rgb(136, 196, 245);
            color: #0057A0;
        }

        .status-Analisando {
            background-color: rgb(245, 238, 136);
            color: rgb(160, 144, 0);
        }

        .status-Recusado {
            background-color: rgb(245, 136, 136);
            color: rgb(160, 0, 0);
        }

        .status-Resolvido {
            background-color: rgb(167, 245, 136);
            color: rgb(27, 160, 0);
        }

        .status-Pendente {
            background-color: rgb(245, 201, 136);
            color: rgb(160, 104, 0);
        }

        .sla {
            margin-top: 10px;
        }

        .log {
            position: absolute;
            top: 0;
            right: 20px;
            font-size: 16px;
        }

        footer{
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            bottom: -150px;
        }

        a{
            color: #0057A0;
        }
    </style>
    <header>
        <h1>Ocorrências</h1>

        <form action="{{ route('logout') }}" method="post">
            @csrf

            <button class="log" type="submit">Logout</button>
        </form>
    </header>

    <main>
        @foreach($ocorrencias as $ocorrencia)
        <div class="container">
            <p><strong>Titulo: </strong>{{ $ocorrencia->title }}</p>
            <p><strong>Status: </strong><span class="status-badge status-{{ $ocorrencia->status }}">{{ $ocorrencia->status }}</span></p>

            @if($ocorrencia->status == 'Pendente')
            <form class="logout" action="{{ route('ocorrencia.abrir', $ocorrencia->id) }}" method="post">
                @csrf

                <button type="submit">Abrir detalhes</button>
            </form>
            @else
            <button onclick="abrir('{{ $ocorrencia->id }}')">Abrir detalhes</button>
            @endif
        </div>

        <div class="modal" id="modal-{{ $ocorrencia->id }}">
            <div class="modal-content">
                <span class="close" onclick="fechar('{{ $ocorrencia->id }}')">&times;</span>
                <p><strong>Titulo: </strong>{{ $ocorrencia->title }}</p>
                @if($ocorrencia->image)
                <img src="{{ asset('storage/' . $ocorrencia->image) }}" width="200px">
                @endif

                <p><strong>Descrição: </strong>{{ $ocorrencia->descricao }}</p>
                <p><strong>Endereço: </strong>{{ $ocorrencia->endereco }}</p>

                <form action="{{ route('ocorrencia.atualizar', $ocorrencia->id) }}" method="post">
                    @csrf

                    <label for="status">Status: </label>
                    <select name="status" id="status">
                        <option value="Analisando" {{ $ocorrencia->status == 'Analisando' ? 'selected' : '' }}>Analisando</option>
                        <option value="Recusado" {{ $ocorrencia->status == 'Recusado' ? 'selected' : '' }}>Recusado</option>
                        <option value="Resolvido" {{ $ocorrencia->status == 'Resolvido' ? 'selected' : '' }}>Resolvido</option>
                    </select>

                    <label for="comentario_adm">Comentario: </label>
                    <textarea name="comentario_adm" id="comentario_adm"></textarea>

                    <button type="submit">Atualizar</button>
                </form>

                @if($ocorrencia->avaliacao)
                <p class="sla"><strong>Avaliação: </strong>{{ $ocorrencia->avaliacao }}</p>
                @else
                <p class="sla"><strong>Avaliação: </strong>Esta ocorrencia não tem avaliações</p>
                @endif

                <div class="user-info">
                    <p>
                        <strong>Nome: </strong> {{ $ocorrencia->user->name }} <span class="divisoria">|</span>
                        <strong>Telefone: </strong> {{ $ocorrencia->user->telefone }} <span class="divisoria">|</span>
                        <strong>CPF: </strong> {{ $ocorrencia->user->cpf }} <span class="divisoria">|</span>
                    </p>
                </div>
            </div>
        </div>
        @endforeach


    </main>

    <footer>
        <p><strong><a href="{{ route('form') }}">Registrar um novo administrador</a></strong></p>
    </footer>

    <script>
        const opened = "{{ session('opened') }}"
        if (opened) {
            modal = document.getElementById('modal-' + opened)
        }
        if (modal) {
            modal.style.display = 'block'
        }

        function abrir(id) {
            modal = document.getElementById('modal-' + id)
            modal.style.display = 'block'
        }

        function fechar(id) {
            modal = document.getElementById('modal-' + id)
            modal.style.display = 'none'
        }
    </script>
</body>

</html>