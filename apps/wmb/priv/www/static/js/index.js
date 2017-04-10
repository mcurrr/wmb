import 'babel-polyfill';

import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import { AppContainer } from 'react-hot-loader';
import App from './src/containers/app';
import store from './src/store/store';

const rootEl = document.getElementById('main--container');

const Render = (Component) => {
    render(
        <AppContainer>
            <Provider store = {store}>
                <Component />
            </Provider>
        </AppContainer>,
        rootEl
    );
};

Render(App);

if (module.hot) module.hot.accept('./src/containers/App', () => Render(App));
