import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

var apiUrl = "http://192.168.31.22:7545"; //Replace with your API
var httpClient = Client();
var web3client = Web3Client(apiUrl, httpClient);

class EthereumUtils {
  final contractAddress = dotenv.env['CONTRACT_ADDRESS'];

  Future<BigInt> getBalance() async {
    final contract = await getDeployedContract();
    final etherFunction = contract.function("getBalance");
    final result = await web3client.call(contract: contract, function: etherFunction, params: []);
    List<dynamic> res = result;
    return res[0];
  }

  Future<String> sendBalance(int amount) async {
    var bigAmount = BigInt.from(amount);
    EthPrivateKey privateKeyCred = EthPrivateKey.fromHex(dotenv.env['METAMASK_PRIVATE_KEY']!);
    DeployedContract contract = await getDeployedContract();
    final etherFunction = contract.function("sendBalance");
    final result = await web3client.sendTransaction(
        privateKeyCred,
        Transaction.callContract(
          contract: contract,
          function: etherFunction,
          parameters: [bigAmount],
          maxGas: 100000,
        ),chainId: 1337,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  Future<String> withDrawBalance(int amount) async {
    var bigAmount = BigInt.from(amount);
    EthPrivateKey privateKeyCred = EthPrivateKey.fromHex(dotenv.env['METAMASK_PRIVATE_KEY']!);
    DeployedContract contract = await getDeployedContract();
    final etherFunction = contract.function("withDrawBalance");
    final result = await web3client.sendTransaction(
        privateKeyCred,
        Transaction.callContract(
          contract: contract,
          function: etherFunction,
          parameters: [bigAmount],
          maxGas: 100000,
        ),chainId: 1337,
        fetchChainIdFromNetworkId: false);
    return result;

  }

  Future<DeployedContract> getDeployedContract() async {
    // String abiStringFile = await rootBundle.loadString("assets/artifacts/BasicDapp.json");
    String abiStringFile = await rootBundle.loadString("assets/artifacts/count.json");
    var jsonAbi = jsonDecode(abiStringFile);
    final contract = DeployedContract(ContractAbi.fromJson(jsonEncode(jsonAbi["abi"]), "BasicDapp"), EthereumAddress.fromHex(contractAddress!));
    return contract;
  }
}