import humps from 'humps';
import { ALBUMS_URL, RANDOM_URL, TRACKS_URL, RANDOM_NUMBER } from './constants';


export function fetchRandom() {
    return fetch(`${RANDOM_URL}${RANDOM_NUMBER}`)
        .then(res => res.json())
        .then(json => humps.camelizeKeys(json))
        .catch(err => console.error(err));
}

export function fetchAlbum(albumId) {
    return fetch(`${ALBUMS_URL}${albumId}`)
        .then(res => res.json())
        .then(json => humps.camelizeKeys(json))
        .catch(err => console.error(err));
}

export function fetchTrack(trackId) {
    return fetch(`${TRACKS_URL}${trackId}`)
        .then(res => res.json())
        .then(json => humps.camelizeKeys(json))
        .catch(err => console.error(err));
}