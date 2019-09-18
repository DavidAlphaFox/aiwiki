import { BehaviorSubject } from 'rxjs';
import { useState, useEffect, useMemo } from 'react';

export default function useObservable(initFactory, initialState, inputs) {
  const [state, setState] = useState(typeof initialState !== 'undefined' ? initialState : null);

  const { state$, inputs$ } = useMemo(() => {
    const stateSubject$ = new BehaviorSubject(initialState);
    const inputSubject$ = new BehaviorSubject(inputs);

    return {
      state$: stateSubject$,
      inputs$: inputSubject$,
    };
  }, []);

  useEffect(() => {
    inputs$.next(inputs);
  }, inputs || []);

  useEffect(() => {
    let output$ = null;
    if (inputs) {
      output$ = initFactory(inputs$, state$);
    } else {
      output$ = initFactory(state$);
    }
    const subscription = output$.subscribe((value) => {
      state$.next(value);
      setState(value);
    });
    return () => {
      subscription.unsubscribe();
      inputs$.complete();
      state$.complete();
    };
  }, []);
  return state;
}
