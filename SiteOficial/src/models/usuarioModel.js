var database = require("../database/config")

function autenticar(email, senha) {
    var instrucaoSql = `
        SELECT u.idUsuario as idUsuario, u.nome as nomeUsuario, u.CPF as CPFUsuario, u.email as emailUsuario, u.telFixo as telFixoUsuario, u.telCelular as telCelularUsuario, u.dataCriacao as dataCriacaoUsuario, u.fkEmpresa as empresaUsuario, u.fkTipoUsuario as idTipoUsuario , e.nome as nomeEmpresa, t.tipo as funcaoUsuario
        FROM tipoUsuario as t JOIN usuario as u
		ON t.idTipoUsuario = u.fkTipoUsuario
        JOIN empresa as e
        ON u.fkEmpresa = e.idEmpresa
        WHERE email = '${email}' 
        AND senha = sha2('${senha}', 256)  
        `
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function usuariosCadastrados() {
    var instrucaoSql = `
        select u.idUsuario,
        u.nome as nome,
        u.email as email,
        u.cpf as cpf,
        u.telFixo, telFixo, 
        u.telCelular as telCelular,
        e.nome as nomeEmpresa,
        t.tipo as funcao
        from usuario as u join empresa as e
        on u.fkEmpresa = e.idEmpresa join tipoUsuario as t
        on u.fkTipoUsuario = t.idTipoUsuario;`

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}



function cadastrar(nome, CPF, email, telFixo, telCelular, idEmpresa, idTipoUsuario) {
    var instrucaoSql = `
        INSERT INTO usuario (nome, CPF, email, senha, telFixo, telCelular, dataCriacao, fkEmpresa, fkTipoUsuario) VALUES ('${nome}', '${CPF}', '${email}', sha2('AF#${CPF}', 256), '${telFixo}', '${telCelular}', now(), '${idEmpresa}', '${idTipoUsuario}');
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}



module.exports = {
    autenticar,
    cadastrar,
    usuariosCadastrados
};


