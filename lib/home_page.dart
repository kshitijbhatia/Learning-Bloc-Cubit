import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit(super.initialState);

  void increment() => emit(state + 1);

  @override
  void onChange(Change<int> change) {
    super.onChange(change);
    log("Change in Cubit: ${change.currentState} ${change.nextState}");
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    log("Error: ${error}");
  }
}

sealed class CounterEvent {}

class CounterIncrementPressed extends CounterEvent {}

class CounterDecrementPressed extends CounterEvent {}

class CounterState extends Bloc<CounterEvent, int>{
  CounterState(int initialState) : super(initialState) {
    on<CounterIncrementPressed>((event, emit) {
      emit(state + 1);
    },);
  }

  @override
  void onChange(Change<int> change) {
    super.onChange(change);
    log("Change in Bloc: ${change.currentState} ${change.nextState}");
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          if(!context.read<CounterState>().isClosed){
            context.read<CounterState>().add(CounterIncrementPressed());
          }
        },
        icon: const Icon(Icons.add),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.lightBlueAccent,
        alignment: Alignment.center,
        child: BlocConsumer<CounterState, int>(
          listener: (context, state) {
            if(state == 5) {
              context.read<CounterState>().close();
            }
          },
          builder: (context, state) {
            return Text("$state");
          },
        ),
      ),
    );
  }
}