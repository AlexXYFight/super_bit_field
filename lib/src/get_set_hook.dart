class GetSetHook<T> {
  final void Function(T value)? onSet;
  final T Function()? onGet;

  GetSetHook({this.onSet, this.onGet});
}
